
cd "C:\Program Files\Yubico\YubiKey Manager"
.\ykman.exe fido credentials list
# .\ykman.exe fido credentials delete [credential_id]

ssh-keygen -t ed25519-sk -O resident -C "991 Yubikey 5C" -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(15-013-991)"
ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(15-013-991)"

ssh-keygen -t ed25519-sk -O resident -C "545 Yubikey 5 nfc" -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(18-069-545)"
ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(18-069-545)"

ssh-keygen -t ed25519-sk -O resident -C "822 Yubikey 5 nfc" -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-670-822)"
ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-670-822)"

ssh-keygen -t ed25519-sk -O resident -C "275 Yubikey 5C nano (XPS)" -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-397-275)"
ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(16-397-275)"

ssh-keygen -t ed25519-sk -O resident -C "(189) Yubikey 5 nano (NUC12)" -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(13-135-189)"
ssh-keygen -p -f "$ENV:USERPROFILE/.ssh/id_ed25519_sk_(13-135-189)"

.\ykman.exe fido credentials list
.\ykman openpgp info
.\ykman piv info

.\ykman fido access change-pin
