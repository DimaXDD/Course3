create database DictionaryDatabase;

use DictionaryDatabase;

create table dictionary (
                            word varchar(50),
                            translate varchar(50)
);
INSERT INTO dictionary (word, translate) VALUES ('apple', 'яблоко');

-- Вставка нескольких записей в одном запросе
INSERT INTO dictionary (word, translate) VALUES
                                             ('car', 'машина'),
                                             ('book', 'книга'),
                                             ('table', 'стол'),
                                             ('стол', 'table');

select * from dictionary;