aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 219649929413.dkr.ecr.ap-southeast-1.amazonaws.com
docker build -t url-shortener .
docker tag url-shortener:latest 219649929413.dkr.ecr.ap-southeast-1.amazonaws.com/url-shortener:1.3
docker push 219649929413.dkr.ecr.ap-southeast-1.amazonaws.com/url-shortener:1.3
