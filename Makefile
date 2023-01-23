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

deploy/compose/install:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment/compose:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook playbook.yml --inventory ./inventory

deploy/compose/update:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment/compose:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook playbook.yml --inventory ./inventory --tags reference-design

deploy/compose/local:
	git clone git@github.com:obada-foundation/example-client-system $$(pwd)/deployment/compose/reference-design || true

	docker run \
		--rm \
		 -it \
		 -v $$(pwd)/deployment/compose/reference-design/src:/app \
		 -w /app \
		 composer:2.2.12 \
		sh -c "composer install --ignore-platform-req=ext-bcmath"

	docker run \
		--rm \
		-it \
		-v $$(pwd)/deployment/compose/reference-design/src:/app \
		-w /app \
		node:14 \
		sh -c "npm install && npm run dev"


	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/deployment/compose:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook playbook.yml --inventory ./inventory-local --tags reference-design --connection=local
