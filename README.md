# My Project

## Overview
This project includes a Rust backend and a Vue.js frontend.

## Projects
- `backend`: The Rust Actix-web backend.
- `frontend`: The Vite frontend.
- `frontTest`: The Vue.js frontend with TypeScript.

## 需求軟體
- git
- rust 
- npm/nodejs
### For Windows
1. 第一步
```shell
Start-Process powershell -verb runas -ArgumentList "Set-ExecutionPolicy ByPass"
```
2. 第二步
執行prepare.ps1
```shell
.\prepare.ps1
```

### For Mac
1. 第一步
```shell
brew install node@20
brew install rust
brew install git
```

## How to clone Project or Update Project
### Clone Repo
```shell
git clone https://github.com/End-YYDS/rust_vue_jwt.git --recurse-submodules
```
### 更新Submodule版本
```shell
git submodule update --recursive --remote
```
### Push Submodule
只要把 Submodule 當作一般 Repo 操作就可以了，但當 Submodule 有新的 commit 時，SuperRepo 所記錄的 HASH 都會改變，所以如果順序錯了話，會多一次 commit。
比較好的順序如下：
1. 在 Submodule commit 變更。
2. 在 Submodule push 剛剛的 commit。
3. 在 SuperRepo commit 變更 (這裡會包含新的 Submodule HASH)。
4. 在 SuperRepo push 或是使用 ```git push --recurse-submodules=on-demand```就可以省略步驟 2。

## Running the projects
### Backend
Navigate to `backend` and run:
```shell
cargo run
```
### Frontend
Navigate to `frontend` and run:
```shell
npm install
npm run dev 
```

## 其他需要git submodule 可以看這篇
- https://blog.puckwang.com/posts/2020/git-submodule-vs-subtree/#%E6%9B%B4%E6%96%B0-Submodule