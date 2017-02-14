<?php
/**
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @since         0.10.0
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 * @var \App\View\AppView $this
 */
?>
<?= $this->Form->create(null, [
    'horizontal' => true
]) ?>
<?= $this->Form->input('first_name') ?>
<?= $this->Form->input('last_name') ?>
<?= $this->Form->input('email') ?>
<?= $this->Form->input('mobile_phone') ?>
<?= $this->Form->submit('Add') ?>
<?= $this->Form->end() ?>