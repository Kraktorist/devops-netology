import hvac
client = hvac.Client(
    url='http://vault:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
create_response = client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)
print(create_response)

# Читаем секрет
read_response = client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
print(read_response)