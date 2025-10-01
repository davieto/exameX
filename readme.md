# 📘 ExameX

**ExameX** é um aplicativo desenvolvido em **Flutter/Dart** para auxiliar professores e instituições na criação, gestão e correção de provas objetivas, oferecendo dashboards de desempenho detalhados para turmas e cursos.

---

## 🚀 Funcionalidades Principais

- 📷 Leitura de provas objetivas via QR Code e gabarito de quadradinhos  
- 📊 Dashboard de desempenho por turma (médias, estatísticas, distribuição de notas)  
- 📝 Banco de questões categorizadas por matéria e dificuldade  
- 🔄 Geração de múltiplas versões de prova com randomização de questões e alternativas  
- 📑 Exportação de dados para CSV/Excel e provas em PDF personalizadas  
- 🔐 Sistema de permissões (Coordenação e Professores) para segurança e controle  

---

## 🏗️ Estrutura do Projeto

O projeto segue a **Clean Architecture**, organizado em módulos:

lib/
    core/ → utilidades globais, falhas (errors), tema do app
    features/ → módulos de funcionalidades (questoes, provas, dashboard)
        questoes/ → CRUD, importação, categorização de questões
        provas/ → geração, leitura de QR code, exportação PDF
        dashboard/ → dashboards e estatísticas
    shared/ → widgets e serviços reaproveitáveis (ex: PDF, QRCode, CSV)
    main.dart → ponto de entrada do aplicativo


---

## 🛠️ Tecnologias

- **Flutter / Dart** → framework principal do app  
- **Gerência de estado**: Riverpod (recomendado) ou Bloc  
- **Banco local**: SQLite 
- **Exportação relatórios**: CSV, PDF (printing)  
- **Leitura/Geração de QR Code**: qr_code_scanner, qr_flutter  

---

## 🔒 Regras de Git/GitHub

- A branch principal `main` tem **proteção** → só pode ser atualizada via Pull Request.  
- Está bloqueada contra `force push` e exclusão.  
- Recomenda-se trabalhar sempre em branches de feature:

git checkout -b feature/nome-da-feature


---

## 📌 Próximos Passos

- Implementar a base de entidades e usecases (Domain Layer).  
- Criar camada de dados (`data/`) conectando repositórios a SQLite/API.  
- Configurar UI mínima para Questões (CRUD simples).  
- Evoluir integrações: PDF, QR Code, Dashboards.  

---

## 👨‍💻 Contribuição

1. Crie uma **branch** para a sua feature:  
 ```bash
 git checkout -b feature/minha-feature
