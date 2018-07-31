# Docker中文文档学习过程中的坑

[Docker中文文档](https://docs.docker-cn.com)

---

1. 在[Docker入门](https://docs.docker-cn.com/get-started/)部分的[入门，第3部分：服务](https://docs.docker-cn.com/get-started/part3/)的子章节[您的第一个-docker-composeyml-文件](https://docs.docker-cn.com/get-started/part3/#您的第一个-docker-composeyml-文件)中有一个官方`yml`示例文件，yml文件对空格缩进有严格要求，这个文件的格式是错误的，到[这个网站](https://www.bejson.com/validators/yaml/)检测yml文件的格式并修改
2. 服务用来完成负载均衡，再启动服务之前，需要先运行这个服务需要的容器；在服务启动之后，需要停止或者删除该容器，否则服务没有效果