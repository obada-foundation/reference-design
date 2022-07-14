SHELL := /bin/sh

certificates: ssh/ssh_key

ssh/ssh_key:
	mkdir -p ssh && docker run \
		-it \
		--rm \
                -v $$(pwd)/ssh:/root/.ssh \
		alpine:3.15 \
		sh -c 'apk add openssh && ssh-keygen -t ed25519 -f $$HOME/.ssh/ssh_key -q -N "" && chown 1000:1000 $$HOME/.ssh/ssh_key'

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
