# Microsoft SQL Server (Mssql) Quick Starter
本リポジトリは、 Mssql コンテナの構築および初期化用 SQL の実行を自動化し、 Mssql コンテナの俊敏な利用開始を可能とします。

## 本リポジトリの用途
以下の目的での利用を想定しています。
* ローカル環境で Mssql を構築し、サンプルアプリケーションの動作を検証する。
* ローカル環境で Mssql を構築し、インテグレーションテストをローカル環境で行う。

## 前提条件
以下のソフトウェアを利用可能な環境を必要とします。
* Docker
* Docker Compose

## Mssql Quick Starter の利用を開始する

### 初期化用 SQL を格納する
以下のパスに初期化用 SQL を格納します。
|Path|Description|
|:--|:--|
|`mssql_quick_starter/DDL/database/`|Database を作成する SQL を格納するディレクトリ|
|`mssql_quick_starter/DDL/table/`|Table を作成する SQL を格納するディレクトリ|
|`mssql_quick_starter/DDL/view/`|View を作成する SQL を格納するディレクトリ|
|`mssql_quick_starter/DML/`|DML を実行する SQL を格納するディレクトリ|

初期化用 SQL は、初期化スクリプトによって
1. `mssql_quick_starter/DDL/database/`
2. `mssql_quick_starter/DDL/table/` 
3. `mssql_quick_starter/DDL/view/`
4. `mssql_quick_starter/DML/`

の順に実行されます。
各ディレクトリの配下に複数の SQL ファイルを格納した場合は、ファイル名を昇順ソートした順に実行されます。
以下は、ディレクトリ構成の例です。
~~~
mssql_quick_starter/
├── DDL
│   ├── database
│   │   └── 00_TestDB.sql
│   ├── table
│   │   ├── 00_table_x.sql
│   │   └── 01_table_y.sql
│   └── view
│       ├── 00_view_x.sql
│       └── 01_view_y.sql
└── DML
    ├── 00_insert_table_x.sql
    └── 01_insert_table_y.sql
~~~

上記の例の場合は、以下の順で実行されます。
1. `mssql_quick_starter/DDL/database/00_TestDB.sql`
2. `mssql_quick_starter/DDL/table/00_table_x.sql`
3. `mssql_quick_starter/DDL/table/01_table_y.sql`
4. `mssql_quick_starter/DDL/view/00_view_x.sql`
5. `mssql_quick_starter/DDL/view/01_view_y.sql`
6. `mssql_quick_starter/DML/00_insert_table_x.sql`
7. `mssql_quick_starter/DML/01_insert_table_y.sql`

### Mssql コンテナを作成する
`mssql_quick_starter` ディレクトリで、以下のコマンドを実行します。
~~~
$ docker-compose up -d
~~~

### セットアップスクリプトで DB を初期化する
以下のコマンドを実行すると、「初期化用 SQL を格納する」で格納した SQL が実行されます。
~~~
$ docker-compose exec mssql /opt/workspace/script/setup.sh [-d] <database>
[Example1]
$ docker-compose exec mssql /opt/workspace/script/setup.sh
[Example2]
$ docker-compose exec mssql /opt/workspace/script/setup.sh -d TestDB
~~~
|Option|Required|Description|
|:--|:--|:--|
|-d|No|`mssql_quick_starter/DDL/database/` 以外の SQL ファイルの開始時に `USE <database>` を実行します。|

以下のエラーが出力される場合は、コンテナが起動途中であるため、数分後に再度コマンドを実行してください。
~~~
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : Login timeout expired.
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : TCP Provider: Error code 0x2749.
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : A network-related or instance-specific error has occurred while establishing a connection to SQL Server. Server is not found or not accessible. Check if instance name is correct and if SQL Server is configured to allow remote connections. For more information see SQL Server Books Online..
~~~

## Mssql Quick Starter の利用を終了する

### Mssql コンテナを削除する
`mssql_quick_starter` ディレクトリで、以下のコマンドを実行します。
~~~
$ docker-compose down
~~~

## 手動メンテナンス

### Mssql コンテナにログインする
~~~
$ docker exec -ti mssql bash
~~~

### Mssql にログインする
~~~
$ /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "P@ssw0rdTemp"
~~~

### DB を切り替える
~~~
USE <database>
GO

[Example]
USE TestDB
GO
~~~

### ユーザーテーブル一覧を取得する
~~~
select * from sys.objects where type = 'U';
GO
~~~

### テーブルのレコード一覧を取得する
~~~
select * from <table>;
GO
[Example]
select * from table_x;
GO
~~~

### Mssql からログアウトする
~~~
exit
~~~

### Mssql コンテナからログアウトする
~~~
exit
~~~