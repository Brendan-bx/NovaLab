# Reconstruction du laboratoire NOVA depuis le dépôt.
# À lancer sur ctrl : cd /vagrant && make all
.PHONY: deps lint keys base cluster harden deploy audit all

export ANSIBLE_CONFIG := /vagrant/ansible/ansible.cfg

deps:
	ansible-galaxy collection install -r ansible/requirements.yaml

lint:
	yamllint .
	ansible-lint

keys:
	@for u in alice bob; do \
	  if [ ! -f "$(HOME)/.ssh/$$u" ]; then \
	    ssh-keygen -q -t ed25519 -N "" -C "$$u@nova" -f "$(HOME)/.ssh/$$u"; \
	    echo "clé $$u créée"; \
	  else \
	    echo "clé $$u déjà présente"; \
	  fi; \
	done
	@for env in preprod prod; do \
	  f="ansible/.vault_pass_$$env"; \
	  if [ ! -s "$$f" ]; then \
	    openssl rand -base64 24 | tr -d '\n' > "$$f"; \
	    chmod 600 "$$f"; \
	    echo "mot de passe Vault $$env créé"; \
	  else \
	    echo "mot de passe Vault $$env déjà présent"; \
	  fi; \
	done

base:
	ansible-playbook ansible/playbooks/baseline.yaml

cluster:
	ansible-playbook ansible/playbooks/cluster.yml

harden:
	ansible-playbook ansible/playbooks/harden.yml

deploy:
	ansible-playbook ansible/playbooks/deploy.yml -e nova_require_approval=false

audit:
	ansible-playbook ansible/playbooks/audit.yml

all: deps lint keys base cluster harden deploy audit
