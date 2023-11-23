package app

import Repositorio
import Temperatura
import com.github.britooo.looca.api.core.Looca
import java.time.LocalDateTime
import javax.swing.JOptionPane

open class Main {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {

            // Cria uma instância do Repositorio para interagir com o banco de dados
            val repositorio = Repositorio()
            repositorio.iniciar()

            // Solicita ao usuário que digite seu e-mail e senha
            val email = JOptionPane.showInputDialog("Olá, digite o seu e-mail:")
            val senha = JOptionPane.showInputDialog("Digite a sua senha:")

            if (email != null && senha != null) {
                // Verifica se o usuário com o e-mail e senha fornecidos existe no banco de dados
                if (repositorio.verificarUsuario(email, senha)) {

                    // Mostra uma mensagem de boas-vindas se o usuário existe
                    JOptionPane.showMessageDialog(
                        null,
                        "Usuário encontrado no banco de dados.",
                        "Bem-vindo (a) novamente!",
                        JOptionPane.INFORMATION_MESSAGE
                    )

                    // Cria uma tabela no banco de dados
                    repositorio.criarTabela()

                    // Cria uma instância do Looca para monitorar processos
                    val looca = Looca()

                    println("Iniciado!")

                    // Loop infinito para monitorar e cadastrar temperaturas a cada 5 segundos
                    while (true) {
                        val temperatura = looca.temperatura
                        val novaTemperatura = Temperatura()

                        // Atualiza a propriedade data_hora antes de cada inserção
                        novaTemperatura.data_hora = LocalDateTime.now()

                        repositorio.cadastrar(novaTemperatura)

                        println("""
                            Temperatura da CPU: $temperatura
                        """.trimIndent())

                        // Aguarda 5 segundos antes da próxima iteração
                        Thread.sleep(5000)
                    }
                } else {
                    // Mostra uma mensagem de erro se o usuário não existe no banco de dados
                    JOptionPane.showMessageDialog(
                        null,
                        "Usuário não encontrado no banco de dados.",
                        "Erro",
                        JOptionPane.ERROR_MESSAGE
                    )
                }
            }
        }
    }
}
