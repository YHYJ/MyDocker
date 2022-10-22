# README

<!-- File: README.md -->
<!-- Author: YJ -->
<!-- Email: yj1516268@outlook.com -->
<!-- Created Time: 2021-09-02 16:02:07 -->

---

## Table of Contents

<!-- vim-markdown-toc GFM -->

<!-- vim-markdown-toc -->

---

在Docker中使用PostgreSQL + PLV8指南

---

1. 拉取支持PLV8的PostgreSQL镜像

    例如'pyramation/postgres-plv8'，它使用的是较新版本的PostgreSQL(v10)和PLV8(v2.3.0)

2. 使用该compose文件启动名为postgres-plv8的容器

3. 创建PLV8扩展(Extension)，有两种方法：

    - 执行`CREATE EXTENSION plv8;`
    - 在SQL客户端（以DBeaver为例）右键单击“扩展”，在子菜单中单击“创建扩展”后选中名为'plv8'的扩展单击'OK'即可
