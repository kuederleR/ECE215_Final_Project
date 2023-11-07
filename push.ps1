$Description = Read-Host -Prompt 'Write a brief description of your changes'
git add *
git commit -m $Description
git push