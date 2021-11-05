## ```.gitignore``` explanation:

```
# excluding .terraform directories
**/.terraform/*

# excluding files with .tfstate extension
*.tfstate

# excluding files which have .tfstate. as a part of the name
*.tfstate.*

# excluding files named crash.log
crash.log

# excluding files with .tfvars extension
*.tfvars

# excluding override.tf file
override.tf
# excluding override.tf.json file
override.tf.json
# excluding files with _override.tf and _override.tf.json endings
*_override.tf
*_override.tf.json

# Excluding files named .terraformrc and terraform.rc 
.terraformrc
terraform.rc
```

## Commit history

```
PS C:\Users\user\repos\do> git log -q
commit dd3a00e4090f919294a1350180ccf71013a39723 (HEAD -> main, origin/main, origin/HEAD)
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:45:04 2021 +0300

    Moved and deleted

commit 16c1830669941ff5c2032034747314e2161932a1
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:43:28 2021 +0300

    Prepare to delete and move

commit d059324dfade34a25a1f9f084fdaa97ab1144301
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:42:06 2021 +0300

    Added gitignore

commit 723d9cdadc7ca4d15e1f818309fd3cf87caaf95d
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:18:45 2021 +0300

    renaming README to README.md

commit 56bd36baa3ef841317147bc726b012a4645bd579
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:15:32 2021 +0300

    First commit

commit 3dad1667ba7dfe4e74e7f55624e231ad02e081b4
Author: Mikhail Kharybin <qamo@yandex.ru>
Date:   Mon Nov 1 20:11:18 2021 +0300

    adding root README
```
