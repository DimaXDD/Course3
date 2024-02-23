import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab

dataset = pd.read_csv("final_book_dataset_kaggle2.csv")

print(dataset.columns)
print(dataset.head())

# Гистограмма распределения исходного датасета до обработки пропусков
plt.figure(figsize=(10, 6))
plt.hist(dataset["price"], bins=10, color='blue', alpha=0.5)
plt.xlabel("Price")
plt.ylabel("Frequency")
plt.title("Histogram of Price Distribution (Before Handling Missing Values)")
plt.show()

# Тепловая карта
cols = dataset.columns[:]
colours = ['#eeeeee', '#ff0000']
plt.figure(figsize=(10, 6))
sns.heatmap(dataset[cols].isnull(), cmap=sns.color_palette(colours))
plt.show()

# Проверка на наличие нулевых значений
print(dataset.isnull().any())

# Подсчет количество нулевых значений по столбцам
for col in dataset.columns:
    pct_missing = dataset[col].isnull().sum()
    print('{} - {}'.format(col, round(pct_missing)))

# Подсчет процента нулевых значений по столбцам
for col in dataset.columns:
    pct_missing = np.mean(dataset[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))


# Смотрим, что мы можем удалить без вреда
# NaN есть практически во всех столбцах, кроме первого и двух последних
# Будем удалять столбец weight (много причин, да и % у него относительно большой)
dataset = dataset.drop(["weight"],axis=1)
print(dataset.columns)
print(dataset.head())

# Пустые значения в поле price логично заменить на среднее
dataset["price"] = dataset["price"].fillna(dataset["price"].mean())
print(dataset["price"])

# Пришло осознание (удаляем ненужное)
dataset = dataset.drop(['dimensions','ISBN_13','price (including used books)','publisher','link','complete_link'],axis=1)
dataset.head()

# Тепловая карта
cols = dataset.columns[:]
colours = ['#eeeeee', '#ff0000']
plt.figure(figsize=(10, 6))
sns.heatmap(dataset[cols].isnull(), cmap=sns.color_palette(colours))
plt.show()

# Заменим текст числами
# Датасет у меня плохой, особо текст на числа не заменить, но есть выход)))
dataset['language'] = dataset['language'].map({'English': 1, 'Spanish': 2}).fillna(3)


# Гистограмма распределения датасета после обработки пропусков
plt.figure(figsize=(10, 6))
plt.hist(dataset["price"], bins=10, color='green', alpha=0.5)
plt.xlabel("Price")
plt.ylabel("Frequency")
plt.title("Histogram of Price Distribution (After Handling Missing Values)")
plt.show()


# До изменения (1 MB)
print(dataset.dtypes)
print(dataset.info(memory_usage='deep'))

# =============================== Задание 5 ===============================
top_10_prices = dataset["price"].nlargest(10)
print(top_10_prices)

# Определение списка столбцов, которые нужно проверить на выбросы
columns_to_check = ['price']

# Функция для удаления аномальных записей на основе IQR
def remove_outliers_iqr(data, column):
    Q1 = np.percentile(data[column], 25)
    Q3 = np.percentile(data[column], 75)
    IQR = Q3 - Q1
    threshold = 1.5 * IQR
    data = data[(data[column] >= Q1 - threshold) & (data[column] <= Q3 + threshold)]
    return data

# Цикл для проверки и удаления выбросов для каждого столбца
for column in columns_to_check:
    dataset = remove_outliers_iqr(dataset, columns_to_check)

top_10_prices = dataset["price"].nlargest(10)
print(top_10_prices)


# =============================== Задание 6 ===============================
# Список полей, которые вы хотите заменить на числовой тип данных
fields_to_convert = ['price', 'avg_reviews', 'pages','n_reviews','star5', 'star4', 'star3', 'star2', 'star1']
# Цикл для замены типа данных для каждого поля
for field in fields_to_convert:
    if dataset[field].dtype == object:  # Проверка, что тип данных поля является строковым
        dataset[field] = pd.to_numeric(dataset[field].str.rstrip('%'), errors='coerce')


# После изменения (116.8 KB)
print(dataset.dtypes)
print(dataset.info(memory_usage='deep'))


dataset.to_csv("final_book_clear.csv")