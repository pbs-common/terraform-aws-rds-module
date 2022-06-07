package test

import (
	"fmt"
	"os"
	"testing"

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
}
