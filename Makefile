data/lcms_districts.json:
	curl -sS -H "lcms-api: locator" https://locator.lcms.org/api/dropdown/districts/ > data/lcms_districts.json

