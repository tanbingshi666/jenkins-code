# jdk 基础环境
FROM openjdk:8-jre-alpine

LABEL maintainer="tanbingshi666@163.com"

# 复制打好的 jar 包
COPY target/*.jar /app.jar

# 容器内时间与宿主机同步配置
RUN  apk add -U tzdata; \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
echo 'Asia/Shanghai' >/etc/timezone; \
touch /app.jar;

# JVM 参数
ENV JAVA_OPTS=""

# 运行参数
ENV PARAMS=""

# 暴露端口
EXPOSE 8080

# 运行
ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -jar /app.jar $PARAMS" ]