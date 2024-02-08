import pandas as pd
import matplotlib.pyplot as plt

def part_MatPlotLib():

    # 2. Импортируйте данный csv-файл в python используя модуль pandas, выведите данные
    # для просмотра.
    df = pd.read_csv('harry_potter_reviews.csv')
    print(df.head())
    print('\n====================================\n')

    # 3. Установите библиотеку визуализации Matplotlib . Постройте гистограмму частот по
    # какому-то определенному столбцу (параметру).
    plt.hist(df['user_sex'], bins=10)
    plt.show()
    print('\n====================================\n')

    # 4. Рассчитайте медиану и среднее значение параметра.
    print(df['user_id'].median())
    print(df['user_id'].mean())
    print('\n====================================\n')

    # 5. Постройте box plot для выбранного параметра. Объясните, что на нем изображено.
    plt.boxplot(df['user_age'])
    plt.show()
    print('\n====================================\n')

    # 6. Примените к выбранному параметру метод .describe(). Поясните параметры метода и
    # полученные результаты.
    print(df['comment'].describe())

    print('\n====================================\n')

    # 7. Сгруппируйте данные по какому-либо признаку и произведите расчет и анализ по
    # каким-либо параметрам. Примеры группировок и рассуждений можно посмотреть в
    # примере Examples/Titanic.html
    print(df.groupby('date').count())

    print('Распределение пользователей по полу')
    user_sex_counts = df.groupby('user_sex').size()
    print(user_sex_counts)
    print('\n====================================\n')

    print('Средний возраст пользователей')
    average_age_by_sex = df.groupby('user_sex')['user_age'].mean()
    print(average_age_by_sex)
    print('\n====================================\n')

    print('Топ-5 стран по количеству пользователей')
    top_countries = df.groupby('user_country').size().sort_values(ascending=False).head(5)
    print(top_countries)
    print('\n====================================\n')

    print('Распределение рейтингов')
    rating_counts = df.groupby('rating').size()
    print(rating_counts)
    print('\n====================================\n')

    print('Самые популярные персонажи (любимые)')
    top_characters = df.groupby('favourite_character').size().sort_values(ascending=False).head(5)
    print(top_characters)
    print('\n====================================\n')


if __name__ == '__main__':
    part_MatPlotLib()


