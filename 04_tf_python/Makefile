clean:
	## removing the binary and the zip archive
	rm py2d.zip

build:
	## zip up the python project
	zip -r py2d.zip ./todos/*

deploy: 
	
	# create a bucket on the localstack s3
	awslocal s3api create-bucket --bucket python-todo

	# copy the archive to the localstack s3
	awslocal s3 cp ./py2d.zip s3://python-todo/py2d.zip

	## initialize the terraform template
	tflocal init

	## apply the changes from the terraform template
	tflocal apply