# Vault login docker

## 目标

多节点配置docker拉取私有仓库镜像

## 目录结构

```ini
vault_login_docker/
├── site.yml                           # playbook入口
├── clients.yml                        # 待部署环境的playbook
├── inventories                        # 主机清单
│   └── hosts
└── roles
    └── common                         
        ├── files
        │   ├── config                 # 演示 - ssh_config
        │   ├── config.hcl             # vault 配置文件
        │   ├── config.json            # docker 配置文件
        │   ├── test-vault-role-id     # approle id 配置文件
        │   └── test-vault-secret-id   # secret id 配置文件
        ├── tasks                      
        │   ├── handle_docker.yml      # 镜像拉取
        │   ├── main.yml               # task入口, 决定common顺序
        │   ├── pre_env.yml            # 准备环境
        │   ├── tmp_get_crt.yml        # 演示 - 获取docker仓库crt证书
        │   └── vault_config.yml       # 配置vault以及docker-credential-vault-login
        └── vars
            └── main.yml               # 参数文件

```

## 使用

1. 安装ansible(若无Python3环境, 请先安装)

    ```shell
    $ python3 -m pip install ansible
    ```

2. 修改ansible配置文件, 追加如下内容

    ```ini
    # /etc/ansible/ansible.cfg
    [defaults]
    host_key_checking = False
    ```

3. 准备待部署主机

    修改`vault_login_docker/inventories/hosts`, 添加所需主机

4. 检查主机是否连接成功

    ```shell
    $ ansible ping -i $(PWD)/inventories/hosts
    ```

5. 修改相关配置文件

   - config.hcl: 修改docker仓库地址相关字段
   - config.json: 修改docker仓库地址相关字段
   - test_vault_role_id: `approle` id文件
   - test_vault_secret_id: `vault` secret文件
   - vars/main.yml: docker地址、vault地址、所有拉取镜像

6. 运行脚本

    ```shell
    $ ansible-playbook -i [目录]/inventories/hosts site.yml
    ```

## 脚本流程介绍

1. 配置环境
    
    (1) 安装docker, unzip; 
    
    (2) 获取vault、docker-credential-vault-login压缩包并解压到相应位置；

2. 配置vault以及docker-credential-vault-login

    (1) 导入`approle id`认证文件以及vault配置文件

3. docker操作

    拉取镜像
