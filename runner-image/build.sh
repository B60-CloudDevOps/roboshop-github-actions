git pull
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/w2x3d9u7
docker build -t public.ecr.aws/w2x3d9u7/runner:latest .
docker push public.ecr.aws/w2x3d9u7/runner:latest
