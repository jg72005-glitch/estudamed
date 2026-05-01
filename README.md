# Plataforma EstudaMed

Site estatico para GitHub Pages com login local de teste e modo em nuvem com Supabase Auth.

## Recursos principais

- Login local de teste ou login em nuvem com e-mails permitidos no Supabase
- Dados salvos por usuario, com estado separado por login
- Recuperacao de senha por e-mail quando o Supabase estiver configurado
- Configuracoes internas com perfil, foto, e-mail de lembretes, redefinicao de senha e reset de progresso
- Cronograma livre, sem conteudo ENARE/ENAMED pre-carregado
- Abas internas com transicao suave e suporte mobile
- Mentor em formato de chat, com historico, novo chat, fixar, renomear, projetos, anexos, microfone e compartilhamento
- Revisoes programadas por recuperacao ativa, repeticao espacada, intercalamento e aprofundamento conforme desempenho
- Aba Conteudos em estilo NotebookLM, com notebooks, fontes, leitura de PDF pesquisavel via PDF.js, resumo, chat, mapa mental, relatorio, resumo em audio e flashcards viraveis
- Sessao interna de estudo ao clicar numa tarefa da semana, com acertos, erros, score, dificuldade, Pomodoro e conclusao/reprogramacao automatica
- Graficos e progresso integrados, mostrando questoes, erros, frequencia por materia e revisoes geradas pela dificuldade
- Contador de questoes feitas, atividades externas, videoaulas e tempo de plataforma

## Acesso local de teste

- Usuario: `Jacinto`
- Senha: `2708`

ou

- Usuario: `Raphael`
- Senha: `2708`

## Publicar no GitHub Pages

Envie estes arquivos para a raiz do repositorio:

- `index.html`
- `supabase-config.js`
- `supabase-config.example.js`
- `supabase-estudamed.sql`
- `.nojekyll`
- `README.md`

Depois, no GitHub:

1. Abra `Settings` > `Pages`.
2. Em `Build and deployment`, selecione `Deploy from a branch`.
3. Escolha a branch `main` e a pasta `/root`.
4. Salve e aguarde o link do GitHub Pages.

## Configurar Supabase

1. Crie um projeto no Supabase.
2. Abra `SQL Editor` e rode `supabase-estudamed.sql`.
3. Edite a lista final do SQL com os e-mails permitidos.
4. Em `Authentication`, permita login por e-mail/senha.
5. Copie a `Project URL` e a `anon public key`.
6. Edite `supabase-config.js`:

```js
window.ESTUDAMED_SUPABASE = {
  url: "https://SEU-PROJETO.supabase.co",
  anonKey: "SUA_SUPABASE_ANON_KEY",
};
```

## Recuperacao de senha

O site chama `resetPasswordForEmail`, `verifyOtp` e `updateUser` do Supabase. Para codigo por e-mail, configure o template de recuperacao do Supabase para enviar o token/codigo. Se preferir o fluxo padrao por link, o usuario abre o link recebido e redefine a senha na aba Configuracoes.

## E-mails automaticos

GitHub Pages nao executa tarefas em segundo plano. A plataforma consegue preparar avisos, abrir o cliente de e-mail e salvar lembretes; envio automatico diario real exige backend/Edge Function ou outro servico de automacao ligado ao Supabase.
