<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.lang.reflect.InvocationTargetException" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Студенческая информационная система</title>
    <script>
    function searchStudents() {
        var searchQuery = document.getElementById("searchQuery").value;

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("output").innerHTML = xhr.responseText;
            }
        };

        xhr.open("POST", "?action=searchStudents&searchQuery=" + encodeURIComponent(searchQuery), true);
        xhr.send();
    }

    function getStudents() {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    document.getElementById("output").innerHTML = xhr.responseText;
                }
            };
            xhr.open("POST", "?action=getStudents", true);
            xhr.send();
        }
    </script>
</head>
<body>
<%
    // Обработка данных при отправке формы
    if (request.getParameter("action") != null) {
        if (request.getParameter("action").equals("addStudent")) {
            // Логика добавления студента в базу данных
            // Получение данных из параметров запроса
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String middleName = request.getParameter("middleName");
            int course = Integer.parseInt(request.getParameter("course"));
            String faculty = request.getParameter("faculty");
            String studyForm = request.getParameter("studyForm");
            String scholarship = request.getParameter("scholarship");
            int orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
            String orderDate = request.getParameter("orderDate");
            String issuanceEndDate = request.getParameter("issuanceEndDate");
            String foundationEndDate = request.getParameter("foundationEndDate");
            String foundationReason = request.getParameter("foundationReason");

            try {
                String url = "jdbc:mysql://localhost:3306/students";
                String username = "root";
                String password = "root";

                try {
                    Class.forName("com.mysql.jdbc.Driver").getDeclaredConstructor().newInstance();
                } catch (InstantiationException | IllegalAccessException | InvocationTargetException |
                         NoSuchMethodException | ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }

                try (Connection conn = DriverManager.getConnection(url, username, password)) {
                    String sql = "INSERT INTO students_univ " +
                            "(firstName, lastName, middleName, course, faculty, studyForm, scholarship, orderNumber, orderDate, issuanceEndDate, foundationEndDate, foundationReason) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement statement = conn.prepareStatement(sql)) {
                        statement.setString(1, firstName);
                        statement.setString(2, lastName);
                        statement.setString(3, middleName);
                        statement.setInt(4, course);
                        statement.setString(5, faculty);
                        statement.setString(6, studyForm);
                        statement.setString(7, scholarship);
                        statement.setInt(8, orderNumber);
                        statement.setString(9, orderDate);
                        statement.setString(10, issuanceEndDate);
                        statement.setString(11, foundationEndDate);
                        statement.setString(12, foundationReason);

                        statement.executeUpdate();
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

            } catch(Exception ex){
                System.out.println("...");
            }
            finally {
                System.out.println("---");
            }

                // Здесь нужно добавить логику сохранения данных в базу данных
            // Пример: StudentDAO.addStudent(firstName, lastName, ...);
        } else if (request.getParameter("action").equals("getStudents")) {
            // Логика получения информации из базы данных
            // Здесь нужно добавить логику получения данных из базы данных
            // Пример: List<Student> students = StudentDAO.getAllStudents();
            // Далее можно использовать переменную students для вывода информации в HTML
            PrintWriter writer = response.getWriter();
            try {
                String url = "jdbc:mysql://localhost:3306/students";
                String username = "root";
                String password = "root";

                Class.forName("com.mysql.jdbc.Driver").getDeclaredConstructor().newInstance();

                try (Connection conn = DriverManager.getConnection(url, username, password)) {
                    Statement statement = conn.createStatement();
                    ResultSet resultSet = statement.executeQuery("SELECT * FROM students_univ");



                    writer.println("<table>\n" +
                            "  <tr>\n" +
                            "    <th>ID</th>\n" +
                            "    <th>Фамилия</th>\n" +
                            "     <th>Имя</th>\n" +
                            "     <th>Отчество</th>\n" +
                            "     <th>Курс</th>\n" +
                            "     <th>Факультет</th>\n" +
                            "     <th>Форма обучения</th>\n" +
                            "     <th>Стипендия</th>\n" +
                            "     <th>Номер приказа</th>\n" +
                            "     <th>Дата приказа</th>\n" +
                            "     <th>Дата окончания выдачи по каждому из приказов</th>\n" +
                            "     <th>Окончание срока основания</th>\n" +
                            "     <th>Основание</th>\n" +
                            "  </tr>\n");

                    while(resultSet.next()){
                        int id = resultSet.getInt("id");
                        String firstName = resultSet.getString("firstName");
                        String lastName = resultSet.getString("lastName");
                        String middleName = resultSet.getString("middleName");
                        int course = resultSet.getInt("course");
                        String faculty = resultSet.getString("faculty");
                        String studyForm = resultSet.getString("studyForm");
                        String scholarship = resultSet.getString("scholarship");
                        int orderNumber = resultSet.getInt("orderNumber");
                        String orderDate = resultSet.getString("orderDate");
                        String issuanceEndDate = resultSet.getString("issuanceEndDate");
                        String foundationEndDate = resultSet.getString("foundationEndDate");
                        String foundationReason = resultSet.getString("foundationReason");

                        writer.println("  <tr>\n" +
                                "    <td>" + id + " </td>\n" +
                                "    <td> " + lastName + " </td>" +
                                "<td> "+ firstName +" </td>" +
                                "<td> "+ middleName +" </td>" +
                                "<td> "+ course +" </td>" +
                                "<td> "+ faculty +" </td>" +
                                "<td> "+ studyForm +" </td>" +
                                "<td> "+ scholarship +" </td>" +
                                "<td> "+ orderNumber +" </td>" +
                                "<td> "+ orderDate +" </td>" +
                                "<td> "+ issuanceEndDate +" </td>" +
                                "<td> "+ foundationEndDate +" </td>" +
                                "<td> "+ foundationReason +" </td>" +
                                "  </tr>\n");
                    }
                    writer.println("</table>");
                }

            } catch (Exception ex) {
                writer.println("Connection failed...");
                writer.println(ex);
            } finally {
                writer.close();
            }
        } else if (request.getParameter("action").equals("searchStudents")) {
            PrintWriter writer = response.getWriter();
            try {
                String url = "jdbc:mysql://localhost:3306/students";
                String username = "root";
                String password = "root";

                Class.forName("com.mysql.jdbc.Driver").getDeclaredConstructor().newInstance();

                try (Connection conn = DriverManager.getConnection(url, username, password)) {
                    Statement statement = conn.createStatement();

                    String searchQuery = request.getParameter("searchQuery");

                    // Переменная для хранения SQL-запроса
                    String sqlQuery;

                    // Проверяем, есть ли параметр поиска
                    if (searchQuery != null && !searchQuery.isEmpty()) {
                        // Модифицируем SQL-запрос для учета параметра поиска
                        sqlQuery = "SELECT * FROM students_univ " +
                                   "WHERE firstName LIKE '%" + searchQuery + "%' OR " +
                                   "lastName LIKE '%" + searchQuery + "%' OR " +
                                   "middleName LIKE '%" + searchQuery + "%'";
                    } else {
                        // В случае отсутствия параметра поиска, просто получаем всех студентов
                        writer.println("По этому запросу нету данных!");
                        sqlQuery = "SELECT * FROM students_univ";
                    }

                    ResultSet resultSet = statement.executeQuery(sqlQuery);

                    writer.println("<table>\n" +
                                   "  <tr>\n" +
                                   "    <th>ID</th>\n" +
                                   "    <th>Фамилия</th>\n" +
                                   "     <th>Имя</th>\n" +
                                   "     <th>Отчество</th>\n" +
                                   "     <th>Курс</th>\n" +
                                   "     <th>Факультет</th>\n" +
                                   "     <th>Форма обучения</th>\n" +
                                   "     <th>Стипендия</th>\n" +
                                   "     <th>Номер приказа</th>\n" +
                                   "     <th>Дата приказа</th>\n" +
                                   "     <th>Дата окончания выдачи по каждому из приказов</th>\n" +
                                   "     <th>Окончание срока основания</th>\n" +
                                   "     <th>Основание</th>\n" +
                                   "  </tr>\n");

                    while(resultSet.next()){
                        int id = resultSet.getInt("id");
                        String firstName = resultSet.getString("firstName");
                        String lastName = resultSet.getString("lastName");
                        String middleName = resultSet.getString("middleName");
                        int course = resultSet.getInt("course");
                        String faculty = resultSet.getString("faculty");
                        String studyForm = resultSet.getString("studyForm");
                        String scholarship = resultSet.getString("scholarship");
                        int orderNumber = resultSet.getInt("orderNumber");
                        String orderDate = resultSet.getString("orderDate");
                        String issuanceEndDate = resultSet.getString("issuanceEndDate");
                        String foundationEndDate = resultSet.getString("foundationEndDate");
                        String foundationReason = resultSet.getString("foundationReason");

                        writer.println("  <tr>\n" +
                                       "    <td>" + id + " </td>\n" +
                                       "    <td> " + lastName + " </td>" +
                                       "<td> "+ firstName +" </td>" +
                                       "<td> "+ middleName +" </td>" +
                                       "<td> "+ course +" </td>" +
                                       "<td> "+ faculty +" </td>" +
                                       "<td> "+ studyForm +" </td>" +
                                       "<td> "+ scholarship +" </td>" +
                                       "<td> "+ orderNumber +" </td>" +
                                       "<td> "+ orderDate +" </td>" +
                                       "<td> "+ issuanceEndDate +" </td>" +
                                       "<td> "+ foundationEndDate +" </td>" +
                                       "<td> "+ foundationReason +" </td>" +
                                       "  </tr>\n");
                    }
                    writer.println("</table>");
                }


            } catch (Exception ex) {
                writer.println("Connection failed...");
                writer.println(ex);
            } finally {
                writer.close();
            }
        }
    }
%>

<h2>Добавить студента</h2>
<form method="post" action="?action=addStudent">
    Имя: <input type="text" name="firstName" required><br>
    Фамилия: <input type="text" name="lastName" required><br>
    Отчество: <input type="text" name="middleName"><br>
    Курс: <input type="number" name="course" required><br>
    Факультет:
    <select name="faculty">
        <!-- Здесь добавьте опции для всех факультетов -->
        <option value="Биологический">Биологический</option>
        <option value="Востоковедения">Востоковедения</option>
        <option value="Физкультурный">Физкультурный</option>
        <option value="Социальный">Социальный</option>
        <option value="Исторический">Исторический</option>
        <option value="ФИЯ">ФИЯ</option>
        <option value="ФИиИТ">ФИиИТ</option>
        <option value="Культуры">Культуры</option>
        <option value="Математический">Математический</option>
        <option value="Психологии и философии">Психологии и философии</option>
        <option value="Физический">Физический</option>
        <option value="Филологический">Филологический</option>
        <option value="Химический">Химический</option>
        <option value="Экологии">Экологии</option>
        <option value="Экономики">Экономики</option>
        <option value="Юридический">Юридический</option>
        <!-- Добавьте остальные опции -->
    </select><br>
    Форма обучения:
    <input type="radio" name="studyForm" value="Бакалавриат" required> Бакалавриат
    <input type="radio" name="studyForm" value="Магистратура" required> Магистратура<br>
    Стипендия:
    <input type="radio" name="scholarship" value="Социальная"> Социальная
    <input type="radio" name="scholarship" value="В повышенном размере"> В повышенном размере<br>
    Номер приказа: <input type="number" name="orderNumber" required><br>
    Дата приказа: <input type="date" name="orderDate" required><br>
    Дата окончания выдачи: <input type="date" name="issuanceEndDate" required><br>
    Окончание срока основания: <input type="date" name="foundationEndDate" required><br>
    Основание:
    <select name="foundationReason">
        <option value="УСЗН">УСЗН</option>
        <option value="Инвалидность">Инвалидность</option>
        <option value="Постановление">Постановление</option>
    </select><br>
    <input type="submit" value="Добавить студента">
</form>

<hr>

<%--<h2>Получить информацию из БД</h2>--%>
<%--<form method="post" action="?action=getStudents">--%>
<%--    <input type="submit" value="Получить информацию">--%>
<%--</form>--%>

<%
    // Вывод информации из базы данных
    // Здесь можно использовать переменную students, полученную из базы данных
    // Пример: for (Student student : students) { out.println(student.toString()); }
%>

<h2>Получить информацию из БД</h2>
<button onclick="getStudents()">Получить информацию</button>

<form method="get" onsubmit="event.preventDefault(); searchStudents();">
    <label for="searchQuery">Поиск: </label>
    <input type="text" id="searchQuery" name="searchQuery" placeholder="Введите имя, фамилию или отчество">
    <input type="submit" value="Искать">
</form>

<!-- Вывод информации -->
<div id="output"></div>

</body>
</html>
