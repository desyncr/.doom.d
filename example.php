<?php

/**
 *
 */
class Example
{
    /**
     * @var string Too short a description
     */
    private $var;

    /**
     * __construct
     *
     * @param Exception $e
     *
     * @return self
     */
    public function __construct(Exception $e): self
    {
        $a = [-1,2,3,4];
    }

    /**
     * Returns an array of randomly generated integers.
     *
     * @param int $count missing parameter comment
     *
     * @return array
     */
    public function getRandomNumbersIterative(int $count): array
    {
        $result = [];
        for (; $count >= 0; $count--) {
            array_push(
                $result,
                chr(
                    rand(
                        48,
                        56
                    )
                )
            );
        }

        for (
            ; $count >= 0; $count--
        ) {
            array_push(
                $result,
                chr(
                    rand(
                        48,
                        56
                    )
                )
            );
        }

        return $result;
    }

    public function printRandomNumbers(): void
    {
        echo join(
            ', ',
            $this->getRandomNumbersIterative(
                10
            )
        ) . PHP_EOL;
    }

    private function example(): bool
    {
        return false;
    }
}


$example = new Example();
$example->printRandomNumbers();
