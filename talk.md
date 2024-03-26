---
marp: true
theme: default
class: 
  - lead
  - invert
---

# Content Block com Swift UI

---

# O que é a API de Content Block?

Content blockers são extensões que permitem o seu app indicar para o Safari que tipos de regras ( bloqueio de conteudo, remoção de cookies) ele deve executar.

---

# Como funciona ?

Quando o bloqueador de conteudo é lançado ele consulta o app container que se comunica diretamente com o Safari. Assim o Safari sabe previamente o que ele deve filtrar ou não, sem precisar executar o aplicativo em tempo de execução. Tornando a navegação anonima e segura.

![](https://docs-assets.developer.apple.com/published/29c72556b7/renderedDark2x-1656100559.png)

---

# Como Usar a API de Bloco de Conteúdo

Toda configuração pode ser feita atravês de um arquivo JSON. O Safari analisa todos os triggers e enfileira as actions executando em ordem.

```json
[
    {
        "trigger": {
            ...
        },
        "action": {
            ...
        }
    },
    {
        "trigger": {
            ...
        },
        "action": {
            ...
        }
    }
]
```
---

# Triggers
Com triggers você pode definir padrões de captura, filtrando dominio, tipo de conteudo etc
```json
"trigger": {
        "url-filter": ".*",
        "resource-type": ["image", "style-sheet"],
        "unless-domain": ["your-content-server.com", "trusted-content-server.com"]
}
```
---

# Actions
Após uma trigger ser acionada, você pode escolher os tipos de ações a ser realizada. 
```json
"action": {
        "type": "css-display-none",
        "selector": "#newsletter, :matches(.main-page, .article) .news-overlay"
}
```
---

# Actions
## Os tipos de action podem ser
| Syntax    | Descrição |
| -------- | ------- |
| block  | Não carrega o recurso. Se tiver em cache ignora    |
| block-cookies | Remove os cookies do header antes de enviar para o servidor    |
| css-display-none    | Esconde elementos baseado em seletores CSS.    |
| ignore-previous-rules    | Ignora regras anteriores.    |
| make-https   | Troca a URL http para https |

---

# Ta mais como eu bloqueio uma propaganda?

Alguns dos bloqueadores utilizam uma lista, como essa por exemplo https://easylist-downloads.adblockplus.org/easylist.txt, onde você pode encontrar desde dominios a serem bloqueados até seletores CSS de propagandas mais conhecidas. Com isso basta converter em JSON no formato esperado.

---

# Ta mais como eu bloqueio uma propaganda?
Ao carregar a lista ( atravês de um arquivo local ou até mesmo Firebase) vamos usar o protocolo `NSExtensionRequestHandling` e o metodo `beginRequest` onde podemos passar a nossa lista no tratamento da request.

```swift

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}

```

---

# Live Coding

---
# Live Coding
1. Crie um projeto Xcode, crie um app multiplataforma em SwiftUI
2. Substitua o body do ContentView pelo seguinte.

```swift
    var body: some View {
        VStack {
            Image(systemName: "safari")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Abra as configurações do Safari!")
            Button("Abrir") {
                // Get the settings URL and open it
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
    }

```
---
# Live Coding
3. Adicione um novo target do tipo Content Blocker Extension.
4. Troque o import do arquivo `ContentBlockerRequestHandler` para `import SafariServices`. Esse import torna a extensão multiplataforma dando suporte tanto para iOS quanto para macOS.

---
# Live Coding
5. Altere arquivo `blockerList.json` com o seguinte conteudo:
```json
[
    {
        "action": {
            "type": "block"
        },
        "trigger": {
            "url-filter": "www.google.com"
        }
    }
]

```
6. Rode o aplicativo, em seguida abra as configurações do Safari e ative a extensão.

*Dica: Ao alterar o arquivo `blockerList.json`, você precisa habilitar e desabilitar a extensão para fazer efeito.*

---

# Links

- [Hacking with Swift: Safari Content Blocking](https://www.hackingwithswift.com/safari-content-blocking-ios9)
- [Apple Developer Documentation: Creating a Content Blocker](https://developer.apple.com/documentation/safariservices/creating_a_content_blocker/)
- [Lista de Seletores e Dominios](https://easylist-downloads.adblockplus.org/easylist.txt)
- [Repositorio Open Source DESATUALIZADO](https://github.com/parthjdabhi/Ultimate-AdBlock)
- [Repo da Talk](https://github.com/vrenan/talk-content-block-api.git)
# Minhas Redes
- Github: https://github.com/vrenan
- Linkedin: https://www.linkedin.com/in/victor-travassos/
