# Oathtool to get MFA codes via terminal
# WARNING: MFA should ideally be stored on a different device from a security perspective.
#

case $1 in
	LDAP)
		echo $
		oathtool --base32 --totp "{{ MFA CODE }}" -d 6
		;;
	*)
		echo "No 2FA for $1"
		;;
esac
