<?php

use Gender\Gender;

class NameChecker
{
    public function getSex($name)
    {
        if (!empty($name)) {
            $transliterator = \Transliterator::create('uz_Cyrl-uz_Latn');
            $transliteratedName = $transliterator->transliterate($name);

            $gender = new Gender;
            $country = Gender::RUSSIA;

            $result = $gender->get($transliteratedName, $country);
            $message = '';

            switch($result) {
                case Gender::IS_FEMALE:
                    $message = 'female'; // Женское имя
                break;
                case Gender::IS_MOSTLY_FEMALE:
                    $message = 'female'; //Скорее всего женское имя
                break;
                case Gender::IS_MALE:
                    $message = 'male'; //Мужское имя
                break;
                case Gender::IS_MOSTLY_MALE:
                    $message = 'male'; //Скорее всего мужское имя
                break;
                case Gender::IS_UNISEX_NAME:
                    $message = 'unisex'; //Такое имя годится и для женщин и для мужчин
                break;
                case Gender::IS_A_COUPLE:
                    $message = 'unisex'; //Такое имя может быть и женским и мужским
                break;
                case Gender::NAME_NOT_FOUND:
                    $message = 'error'; // Имя не найдено
                break;
                case Gender::ERROR_IN_NAME:
                    $message = 'error'; // Ошибка в имени
                break;
                default:
                    $message = 'error'; // Произошла ошибка
                break;
            }

            return $message;

        }
    }
}
