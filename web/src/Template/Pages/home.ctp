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
$this->append('css', $this->Html->css('bootstrap-year-calendar.css'));
$this->append('script', $this->Html->script('bootstrap-year-calendar.js'));
?>
<div class="row">
    <div class="col col-md-12">
        <h4>Calendar</h4>
        <div id="calendar" class="calendar"></div>
    </div>
</div>

<script>
    $(function () {
        $('.calendar').calendar()
    });
</script>