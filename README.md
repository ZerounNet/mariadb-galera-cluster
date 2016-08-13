# mariadb-galera-cluster

通过dockerfile构建镜像

	git clone https://github.com/ZerounNet/mariadb-galera-cluster.git
	docker build -t zerounnet/mariadb-galera-cluster mariadb-galera-cluster
	
通过docker仓库获取镜像

	docker pull zerounnet/mariadb-galera-cluster
	

设置集群的IP地址

	host_ip_1=192.168.1.241
	host_ip_2=192.168.1.242
	host_ip_3=192.168.1.243
	password=password
	sst_user=sst
	sst_pass=sst_pass

启动第一个节点

	docker run -d \
	    --name galera-node1 \
	    -h galera-node1 \
	    -p ${host_ip_1}:3306:3306 \
	    -p ${host_ip_1}:4444:4444 \
	    -p ${host_ip_1}:4567:4567 \
	    -p ${host_ip_1}:4568:4568 \
	    -e CLUSTER_NAME=galera-node \
	    -e CLUSTER_IP=${host_ip_1}:4567 \
	    -e CLUSTER=BOOTSTRAP \
	    -e SST_METHOD=xtrabackup-v2 \
	    -e SST_USER=${sst_user} \
	    -e SST_PASS=${sst_pass} \
	    -e MYSQL_ROOT_PASSWORD=${password} \
	    -v /data/dockerfile/mariadb-galera-cluster/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
	    -v /data/volume/mysql1/data:/var/lib/mysql \
	    -v /data/volume/mysql1/custom.cnf:/etc/my.cnf.d/custom.cnf \
	    zerounnet/mariadb-galera-cluster

加入其他节点

	docker run -d \
	    --name galera-node2 \
	    -h galera-node2 \
	    -p ${host_ip_2}:3306:3306 \
	    -p ${host_ip_2}:4444:4444 \
	    -p ${host_ip_2}:4567:4567 \
	    -p ${host_ip_2}:4568:4568 \
	    -e CLUSTER_NAME=galera-node \
	    -e CLUSTER_IP=${host_ip_2}:4567 \
	    -e CLUSTER=${host_ip_1}:4567,${host_ip_2}:4567,${host_ip_3}:4567 \
	    -e SST_METHOD=xtrabackup-v2 \
	    -e SST_USER=${sst_user} \
	    -e SST_PASS=${sst_pass} \
	    -e MYSQL_ROOT_PASSWORD=${password} \
	    -v /data/volume/mysql2/data:/var/lib/mysql \
	    -v /data/volume/mysql2/custom.cnf:/etc/my.cnf.d/custom.cnf \
	    zerounnet/mariadb-galera-cluster
	
	docker run -d \
	    --name galera-node3 \
	    -h galera-node3 \
	    -p ${host_ip_3}:3306:3306 \
	    -p ${host_ip_3}:4444:4444 \
	    -p ${host_ip_3}:4567:4567 \
	    -p ${host_ip_3}:4568:4568 \
	    -e CLUSTER_NAME=galera-node \
	    -e CLUSTER_IP=${host_ip_3}:4567 \
	    -e CLUSTER=${host_ip_1}:4567,${host_ip_2}:4567,${host_ip_3}:4567 \
	    -e SST_METHOD=xtrabackup-v2 \
	    -e SST_USER=${sst_user} \
	    -e SST_PASS=${sst_pass} \
	    -e MYSQL_ROOT_PASSWORD=${password} \
	    -v /data/volume/mysql3/data:/var/lib/mysql \
	    -v /data/volume/mysql3/custom.cnf:/etc/my.cnf.d/custom.cnf \
	    zerounnet/mariadb-galera-cluster
	
