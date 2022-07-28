@echo off
set /p descricaocommit=Descricao:
git add --all
git commit -m "%descricaocommit%"
git push
pause