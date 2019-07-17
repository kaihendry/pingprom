SECRETS := ./.env

alertmanager.yml: alertmanager.yml.in $(SECRETS)
	test -f $(SECRETS) && . $(SECRETS) && envsubst < $< > $@

clean:
	rm alertmanager.yml
