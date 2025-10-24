package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testRDS(t *testing.T, variant string) {
	t.Parallel()

	var privateHostedZone string

	if variant != "no-dns" {
		privateHostedZone = os.Getenv("TF_VAR_private_hosted_zone")

		if privateHostedZone == "" {
			t.Fatal("TF_VAR_private_hosted_zone must be set to run tests. e.g. 'export TF_VAR_private_hosted_zone=example.local'")
		}
	}

	terraformDir := fmt.Sprintf("../examples/%s", variant)

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		LockTimeout:  "5m",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	name := terraform.Output(t, terraformOptions, "name")
	DBAdminPassword := terraform.Output(t, terraformOptions, "db_admin_password")
	DBAdminUsername := terraform.Output(t, terraformOptions, "db_admin_username")
	DBClusterDNS := terraform.Output(t, terraformOptions, "db_cluster_dns")
	SGID := terraform.Output(t, terraformOptions, "sg_id")

	expectedName := fmt.Sprintf("example-tf-rds-%s", variant)

	var expectedDBClusterDNS string

	if variant == "no-dns" {
		partialExpectedDBClusterDNS := expectedName
		assert.Contains(t, DBClusterDNS, partialExpectedDBClusterDNS)
	} else {
		expectedDBClusterDNS = fmt.Sprintf("%s-db.%s", expectedName, privateHostedZone)
		assert.Equal(t, expectedDBClusterDNS, DBClusterDNS)
	}

	assert.Contains(t, name, expectedName)
	assert.NotEmpty(t, DBAdminPassword)
	assert.NotEmpty(t, DBAdminUsername)
	assert.NotEmpty(t, SGID)

	if variant == "lambda" {
		expectedLambdaName := expectedName
		lambdaName := terraform.Output(t, terraformOptions, "lambda_name")
		assert.Equal(t, expectedLambdaName, lambdaName)

		sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})

		if err != nil {
			t.Fatalf("Failed to create AWS Session: %v", err)
		}

		lambdaSvc := lambda.New(sess)

		invokeOutput, err := lambdaSvc.Invoke(&lambda.InvokeInput{
			FunctionName: aws.String(lambdaName),
		})

		if err != nil {
			t.Fatalf("Failed to invoke Lambda: %v", err)
		}

		assert.Equal(t, int64(200), *invokeOutput.StatusCode)
	}
}
