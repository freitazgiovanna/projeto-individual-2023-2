import com.github.britooo.looca.api.core.Looca
import org.springframework.jdbc.core.JdbcTemplate

val looca: Looca = Looca()

class Repositorio {

    lateinit var jdbcTemplate: JdbcTemplate // Declara uma variável para manipulação do banco de dados, o lateinit indica que uma variável será inicializada posteriormente, após a sua declaração, e que você está garantindo que ela não será nula quando for usada.

    // Função para iniciar a conexão com o banco de dados
    fun iniciar() {
        jdbcTemplate = Conexao().conectar() // Cria uma conexão usando a classe Conexao
    }

    // Função para criar uma tabela no banco de dados
    fun criarTabela() {
        jdbcTemplate.execute(
            """
        CREATE TABLE IF NOT EXISTS temperaturaCPU (
        idTempXAtiv INT AUTO_INCREMENT PRIMARY KEY,
        temperatura FLOAT,
        data_hora DATETIME,
        idComp INT,
        idCompATM INT,
        FOREIGN KEY (idComp) REFERENCES Componentes(id),
        FOREIGN KEY (idCompATM) REFERENCES ATM(idATM)
);
        """
        )

    }

    // Função para cadastrar informações sobre um processo no banco de dados
    fun cadastrar(novaTemperatura: Temperatura) {
        jdbcTemplate.update(
            """
            INSERT INTO temperaturaCPU(temperatura, data_hora, idComp, idCompATM) VALUES (?, ?, 3, 1)
        """,
            novaTemperatura.temperatura,
            novaTemperatura.data_hora
        )
    }

    // Função para verificar a existência de um usuário com base em email e senha no banco de dados
    fun verificarUsuario(email: String, senha: String): Boolean {
        val sql = "SELECT COUNT(*) FROM usuario WHERE email = ? AND senha = ?"
        val count = jdbcTemplate.queryForObject(sql, Int::class.java, email, senha)

        return count > 0
    }
}