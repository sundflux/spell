<?php

declare(strict_types=1);

return [
    'packages' => [
        'druidfi/amazeeio-scripts' => [
            'version' => 'dev-master',
        ],
        'drupal/system_status' => [
            'version' => '^2.7',
        ],
    ],

    // Which of the packages belong to require-dev section
    'require-dev' => [
        'druidfi/amazeeio-scripts',
    ],

    'questions' => [
        'amazeeio' => [
            'question' => 'Is this project going to be hosted on Amazee.io or use their development tools?',
            'default' => 1,
            'required'=> true,
            'options' => [
                1 => [
                    'name' => 'Yes',
                    'packages' => [
                        'druidfi/amazeeio-scripts',
                    ],
                    'scripts' => [
                        'update-amazee-scripts' => [
                            'rsync -av vendor/druidfi/amazeeio-scripts/dist/ .',
                            'git status -s',
                        ]
                    ]
                ],
                2 => [
                    'name' => 'No',
                    'packages' => [
                    ],
                ],
            ],
        ],

        'lumturio' => [
            'question' => 'Do you want to have Lumturio monitoring?',
            'default' => 1,
            'required' => true,
            'options' => [
                1 => [
                    'name' => 'Yes',
                    'packages' => [
                        'drupal/system_status',
                    ],
                    'copy' => [
                        //'resources/something.php' => 'something.php',
                    ],
                ],
                2 => [
                    'name' => 'No',
                    'packages' => [
                    ],
                ],
            ],
        ],
    ],
];
