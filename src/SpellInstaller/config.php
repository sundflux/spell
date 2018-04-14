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

    'require-dev' => [
        'druidfi/amazeeio-scripts',
    ],

    'questions' => [
        'amazeeio' => [
            'question'               => 'Is this project going to be hosted on Amazee.io or use their development tools?',
            'default'                => 1,
            'required'               => true,
            'custom-package'         => true,
            //'custom-package-warning' => 'You need to edit public/index.php to start the custom container.',
            'options'                => [
                1 => [
                    'name'     => 'Yes',
                    'packages' => [
                        'druidfi/amazeeio-scripts',
                    ],
                ],
                2 => [
                    'name'     => 'No',
                    'packages' => [
                    ],
                ],
            ],
        ],

        'lumturio' => [
            'question'       => 'Do you want to have Lumturio monitoring?',
            'default'        => 1,
            'required'       => true,
            'custom-package' => false,
            'options'        => [
                1 => [
                    'name'     => 'Yes',
                    'packages' => [
                        'drupal/system_status',
                    ],
                    'copy' => [
                        //'Resources/templates/plates/404.phtml' => 'templates/error/404.phtml',
                    ],
                ],
                2 => [
                    'name'     => 'No',
                    'packages' => [
                    ],
                ],
            ],
        ],
    ],
];
