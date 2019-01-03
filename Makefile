SECRETS := ./.env

alertmanager.yml: alertmanager.yml.in
	test -f $(SECRETS) && . $(SECRETS) && envsubst < $< > $@

clean:
	rm alertmanager.yml
