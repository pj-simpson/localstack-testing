# zip up the python file
# zip -j py2d.zip ./todos/list_all.py

# pip install --target ./04_tf_python/todos aws-lambda-typing

cd todos
zip -r py2d.zip *
cd .. 
mv 


# create a bucket on the localstack s3
awslocal s3api create-bucket --bucket python-todo

# copy the binary to the localstack s3
awslocal s3 cp ./py2d.zip s3://python-todo/py2d.zip