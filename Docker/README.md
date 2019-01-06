docker build -t drorle/opsschool-dummy-exporter .

docker run -d -p 65433:65433 drorle/opsschool:dummy-exporter

docker push drorle/opsschool:dummy-exporter


