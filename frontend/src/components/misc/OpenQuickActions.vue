<script setup lang="ts">
import BaseButton from '@/components/base/BaseButton.vue'
import {useBaseStore} from '@/stores/base'
import {onBeforeUnmount, onMounted} from 'vue'
import {eventToShortcutString} from '@/helpers/shortcut'
import {isAppleDevice} from '@/helpers/isAppleDevice'

const baseStore = useBaseStore()

// See https://github.com/github/hotkey/discussions/85#discussioncomment-5214660
function openQuickActionsViaHotkey(event: KeyboardEvent) {
	const shortcutString = eventToShortcutString(event)
	if (!shortcutString) return

	// On macOS, use Cmd+K (Meta+K), on other platforms use Ctrl+K (Control+K)
	const expectedShortcut = isAppleDevice() ? 'Meta+KeyK' : 'Control+KeyK'
	if (shortcutString !== expectedShortcut) return
	
	event.preventDefault()

	openQuickActions()
}

onMounted(() => {
	document.addEventListener('keydown', openQuickActionsViaHotkey)
})

onBeforeUnmount(() => {
	document.removeEventListener('keydown', openQuickActionsViaHotkey)
})

function openQuickActions() {
	baseStore.setQuickActionsActive(true)
}
</script>

<template>
	<BaseButton
		class="trigger-button"
		:title="$t('keyboardShortcuts.quickSearch')"
		@click="openQuickActions"
	>
		<Icon icon="search" />
		<span class="search-label">{{ $t('quickActions.title') }}</span>
		<kbd class="search-kbd">{{ isAppleDevice() ? '⌘K' : 'Ctrl K' }}</kbd>
	</BaseButton>
</template>

<style lang="scss" scoped>
.search-label,
.search-kbd {
	display: none;
}

@media screen and (min-width: $tablet) {
	// ponytail: looks like a search field, still just opens the quick actions bar
	.trigger-button {
		align-self: center;
		display: inline-flex;
		align-items: center;
		gap: .5rem;
		inline-size: 18rem;
		block-size: 36px;
		padding-inline: .625rem;
		margin-inline-end: .75rem;
		border: 1px solid var(--grey-300);
		border-radius: $radius;
		background: var(--grey-50);
		font-size: .8125rem !important;
	}

	.search-label {
		display: inline;
		color: var(--text-muted);
	}

	.search-kbd {
		display: inline;
		margin-inline-start: auto;
		padding: 0 .3rem;
		border: 1px solid var(--grey-300);
		border-radius: 4px;
		background: var(--white);
		font: inherit;
		font-size: .6875rem;
		color: var(--text-muted);
	}
}
</style>
