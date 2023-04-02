package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/rand"
)

func TestE2E_m4sHcloud(t *testing.T) {
	runTerraformAndVerify(t, "../hcloud")
}

func runTerraformAndVerify(t *testing.T, terraformDir string) {
	t.Parallel()

	prefix := "qs-" + rand.String(5) + "-test"

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"prefix": prefix,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	m4sServerURL := terraform.Output(t, terraformOptions, "m4s_server_url")

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		m4sServerURL,
		&tls.Config{
			InsecureSkipVerify: true,
		},
		30,
		5*time.Second,
		func(statusCode int, body string) bool {
			if statusCode != 200 {
				return false
			}
			return true
		})

	k8sOptions := k8s.NewKubectlOptions("", fmt.Sprintf("%s/kube_config_server.yaml", terraformDir), "cattle-system")

	k8s.WaitUntilAllNodesReady(t, k8sOptions, 10, 5*time.Second)

	m4sPods := k8s.ListPods(t, k8sOptions, metav1.ListOptions{})

	assert.Greater(t, len(m4sPods), 0)

	for _, m4sPod := range m4sPods {
		k8s.WaitUntilPodAvailable(t, k8sOptions, m4sPod.Name, 10, 5*time.Second)
	}
}
