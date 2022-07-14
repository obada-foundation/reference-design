PROJECT = obada/faucet
CI_COMMIT_REF_SLUG ?= develop
SHELL := /bin/sh

customize:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment/customize:/home/ansible/deployment \
		-v $$(pwd)/deployment/compose/inventory:/home/ansible/deployment/inventory \
		obada/ansible \
		ansible-playbook customize.yml --inventory ./inventory

deploy/inventory:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/deployment/compose:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook inventory-playbook.yml --inventory localhost --connection=local --limit 127.0.0.1

deploy/compose:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment/compose:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook playbook.yml --inventory ./inventory
