<?php
/**
 * @var \App\View\AppView $this
 */
?>
<h3>Bulk Send</h3>

<div class="alert alert-info">
    Please upload your file with correct fields
</div>

<?= $this->Form->create() ?>
<?= $this->Form->textarea('sms_text') ?>
<?= $this->Form->end() ?>