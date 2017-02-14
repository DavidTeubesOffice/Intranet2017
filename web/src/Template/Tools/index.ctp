<?php
/**
 * @var \App\View\AppView $this
 */
?>

<div class="row">
    <div class="col col-md-3">
        <div class="panel panel-default">
            <div class="panel-heading">Tools</div>
<!--            <div class="panel-body"></div>-->
            <ul class="list-group">
                <li class="list-group-item"><?= $this->Html->link('Bulk Send', '/Tools/bulksend', []) ?></li>
                <li class="list-group-item"><?= $this->Html->link('Bulk Import', '/Tools/bulkimport', []) ?></li>
            </ul>
        </div>
    </div>
    <div class="col col-md-8"></div>
</div>