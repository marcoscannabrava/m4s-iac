PROVIDERS = hcloud

targets = $(PROVIDERS)

upgrade: $(targets)
	cd $< && terraform init -upgrade

docs: $(targets)
	cd $< && terraform-docs -c ../.terraform-docs-readme.yml .

tfvars: $(targets)
	cd $< && terraform-docs -c ../.terraform-docs-tfvars.yml .

fmt: $(targets)
	cd $< && terraform fmt

validate: $(targets)
	cd $< && terraform validate

plan: $(targets)
	cd $< && terraform plan

apply: $(targets)
	cd $< && terraform apply

.PHONY: test
test:
	cd test/ && go test -v -timeout 45m

.PHONY: clean
clean:
	rm **/terraform.tfstate.backup
