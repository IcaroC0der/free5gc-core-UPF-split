# free5GC - UPF Separado (Topologia Customizada)

Este repositório é uma modificação do projeto open source [free5GC](https://github.com/free5gc/free5gc), com o objetivo de separar a UPF (User Plane Function) da VM principal do núcleo do 5G. Essa separação permite uma arquitetura mais modular, próxima de ambientes reais de telecomunicações, facilitando testes de desempenho e escalabilidade.

---

## 🧪 Contexto do projeto

Este trabalho foi desenvolvido por Ícaro de Paiva Rocha durante uma Iniciação Científica no Laboratório Labora da Universidade Federal de Goiás (UFG), com foco em arquitetura de redes 5G, virtualização e desagregação do plano de controle e plano de usuário.

---

## 🔧 Alterações principais

- Separação da UPF em uma VM dedicada (VM3);
- VM2 mantém os demais componentes do núcleo do 5GC;
- Configuração de múltiplas bridges virtuais para roteamento (br-main, br-core-UPF, xenbr0, etc.);
- Design modular com múltiplas interfaces por VM;
- Topologia adaptada para testes acadêmicos e laboratoriais.

---

## 🖼️ Topologia da rede

![Topologia](./Topology.png)

---

## 💻 Requisitos

- Ubuntu Server (20.04 ou 22.04 recomendado)
- KVM/QEMU com virt-manager ou virsh
- Mínimo de 3 VMs (UE/RAN, Core, UPF)
- Docker e Go (para compilação dos componentes do free5GC)

---

## 🚀 Como usar

1. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/free5gc-upf-separated.git
   cd free5gc-upf-separated

## License

free5GC is now under [Apache 2.0](https://github.com/free5gc/free5gc/blob/master/LICENSE.txt) license.

