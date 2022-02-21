(function () {
  const MENU_OPTION_ATTRIBUTE = 'data-menu-option';
  const MENU_ID_ATTRIBUTE = 'data-menu-option-id';
  const MENU_CTA_ID_ATTRIBUTE = 'data-menu-cta-id';
  const MENU_OPTION_ACTIVE_ATTRIBUTE = 'data-menu-item-active';

  function buildSelectorForAttribute(dataAttribute: string) {
    return `[${dataAttribute}]`;
  }

  function disableMenuItem($item: HTMLButtonElement | HTMLDivElement) {
    $item.setAttribute(MENU_OPTION_ACTIVE_ATTRIBUTE, 'false');
  }

  function enableMenuItem($item: HTMLButtonElement | HTMLDivElement) {
    $item.setAttribute(MENU_OPTION_ACTIVE_ATTRIBUTE, 'true');
  }

  function bootstrapMenuOptions() {
    const $menuOptions: NodeListOf<HTMLButtonElement> = document.querySelectorAll(
      buildSelectorForAttribute(MENU_OPTION_ATTRIBUTE)
    );

    const $menuCtas: NodeListOf<HTMLDivElement> = document.querySelectorAll(
      buildSelectorForAttribute(MENU_CTA_ID_ATTRIBUTE)
    );

    const onMenuOptionButtonClicked = (event: MouseEvent) => {
      const $targetMenuOption = event.currentTarget;
      const targetMenuOptionIdAttributeValue = ($targetMenuOption as HTMLButtonElement).getAttribute(MENU_ID_ATTRIBUTE);
      const $targetCta = document.querySelector(
        buildSelectorForAttribute(`${MENU_CTA_ID_ATTRIBUTE}=${targetMenuOptionIdAttributeValue}`)
      );

      [...$menuOptions, ...$menuCtas].forEach(($menuItem) => {
        disableMenuItem($menuItem);
      });

      enableMenuItem($targetMenuOption as HTMLButtonElement);
      enableMenuItem($targetCta as HTMLDivElement);
    };

    $menuOptions.forEach(($menuOptionButton: HTMLButtonElement) => {
      $menuOptionButton.addEventListener('click', onMenuOptionButtonClicked);
    });
  }

  function bootstrap() {
    bootstrapMenuOptions();
  }

  document.addEventListener('DOMContentLoaded', bootstrap, false);
})();
