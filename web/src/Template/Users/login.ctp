<?php
/**
 * @var \App\View\AppView $this
 */
$this->layout = false;
?>
<?= $this->Html->docType() ?>
<html>
<head>
    <?= $this->Html->charset() ?>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <title>Login</title>
    <?= $this->Html->meta('icon') ?>

    <?= $this->Html->css('bootstrap.css') ?>

    <?= $this->Html->script('jquery-3.1.1.min.js') ?>
    <?= $this->Html->script('bootstrap.js') ?>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col col-md-5 col-md-offset-3">
            <div class="panel panel-default" style="margin-top: 35px">
                <div class="panel-heading">Login</div>
                <div class="panel-body">
                    <?= $this->Form->create() ?>
                    <?= $this->Form->input('email') ?>
                    <?= $this->Form->input('password') ?>
                    <?= $this->Form->submit('Login') ?>
                    <?= $this->Form->end() ?>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
