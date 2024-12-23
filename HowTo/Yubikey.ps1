
cd "C:\Program Files\Yubico\YubiKey Manager"
.\ykman.exe fido credentials list
# .\ykman.exe fido credentials delete [credential_id]

ssh-keygen -a 100 -t ed25519 -f "$ENV:USERPROFILE/.ssh/id_ed25519_bitbucket" -C "bitbucket"

ssh-keygen -a 100 -t ed25519-sk -O resident -O application=ssh:991 -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(15-013-991)" -C "991 Yubikey 5C"
#ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(15-013-991)"
ssh-keygen -a 100 -t ed25519-sk -O resident -O application=ssh:545 -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(18-069-545)" -C "545 Yubikey 5 nfc"
#ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(18-069-545)"
ssh-keygen -a 100 -t ed25519-sk -O resident -O application=ssh:822 -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-670-822)" -C "822 Yubikey 5 nfc"
#ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-670-822)"
ssh-keygen -a 100 -t ed25519-sk -O resident -O application=ssh:275 -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-397-275)" -C "275 Yubikey 5C nano (XPS)" 
#ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-397-275)"
ssh-keygen -a 100 -t ed25519-sk -O resident -O application=ssh:189 -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(13-135-189)" -C "189 Yubikey 5 nano (NUC12)" 
#ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(13-135-189)"

.\ykman.exe fido credentials list
.\ykman openpgp info
.\ykman piv info

.\ykman fido access change-pin
