

## 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

```
    git show --pretty=medium -s aefea
    git show --pretty=format:"hash: %H%nmessage: %B" -s aefea
```

>   hash: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    message: Update CHANGELOG.md

## 2. Какому тегу соответствует коммит 85024d3?

```
git describe --tags --exact-match 85024d3
git tag --points-at 85024d3
```

> v0.12.23

## 3. Сколько родителей у коммита b8d720? Напишите их хеши.

```
git show --pretty=format:"%P" -s b8d720
```

> 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

## 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

```
git show --pretty=format:"%H - %B" -s v0.12.23...v0.12.24^
git show --pretty=format:"%H - %B" -s v0.12.23..v0.12.24^
```

> b14b74c4939dcab573326f4e3ee2a62e23e12f89 - [Website] vmc provider links  
</br>
3f235065b9347a758efadc92295b540ee0a5e26e - Update CHANGELOG.md  
</br>
6ae64e247b332925b872447e9ce869657281c2bf - registry: Fix panic when server is unreachable  
</br>
Non-HTTP errors previously resulted in a panic due to dereferencing the
resp pointer while it was nil, as part of rendering the error message.
This commit changes the error message formatting to cope with a nil
response, and extends test coverage.  
</br>
Fixes #24384  
</br>
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 - website: Remove links to the getting started guide's old location  
</br>
Since these links were in the soon-to-be-deprecated 0.11 language section, I
think we can just remove them without needing to find an equivalent link.  
</br>
06275647e2b53d97d4f0a19a0fec11f6d69820b5 - Update CHANGELOG.md  
d5f9411f5108260320064349b757f55c09bc4b80 - command: Fix bug when using terraform login on Windows  
</br>
4b6d06cc5dcb78af637bbb19c198faff37a066ed - Update CHANGELOG.md  
dd01a35078f040ca984cdd349f18d0b67e486c35 - Update CHANGELOG.md  
225466bc3e5f35baa5d07197bbc079345b77525e - Cleanup after v0.12.23 release  

## 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

```
git log --pickaxe-regex -S'func providerSource\(.*\)' --oneline
# some additional actions might be required. See #7
```

> 8c928e835 main: Consult local directories as potential mirrors of providers

## 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

```
# get the file name where the function is declared
git grep -e 'func globalPluginDirs'
# then get all the commits where it was changed
git log -L :globalPluginDirs:plugins.go -s --oneline
```

> 78b122055 Remove config.go and update things using its aliases  
52dbf9483 keep .terraform.d/plugins for discovery  
41ab0aef7 Add missing OS_ARCH dir to global plugin paths  
66ebff90c move some more plugin search path logic to command  
8364383c3 Push plugin discovery down into command package  

## 7. Кто автор функции synchronizedWriters?
   
```
git log --pickaxe-regex -S'func synchronizedWriters\(.*\)' --pretty=format:"%aN %aE" | tail 1
# As the function was created and then removed we have to pick the second of the entries
```

> Martin Atkins mart@degeneration.co.uk