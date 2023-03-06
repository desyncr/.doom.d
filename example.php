<?php

/**
 *
 */
class Example
{
    /** @var string */
    private $var;

    /**
     *
     */
    public function __construct()
    {
    }

    /**
     * Returns an array of randomly generated integers.
     *
     * @param int $count
     * @return array
     */
    public function getRandomNumbersIterative(int $count): array
    {
        $result = [];
        for (; $count >= 0; $count--) {
            array_push($result, chr(rand(48, 56)));
        }

        return $result;
    }

    public function printRandomNumbers(): void
    {
        echo join(', ', $this->getRandomNumbersIterative(10)) . PHP_EOL;
    }

}


$example = new Example();
$example->printRandomNumbers();
