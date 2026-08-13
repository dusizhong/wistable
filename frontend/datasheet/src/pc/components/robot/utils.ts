const AUTOMATION_SERVICE_ICON_MAP: Record<string, string> = {
  apitable: '/static/icon/automation/apitable.svg',
  webhook: '/static/icon/automation/webhook.svg',
  email: '/static/icon/automation/email.svg',
};

export const getAutomationServiceLogo = (service: { slug: string; logo: string } | undefined | null): string => {
  if (!service) return '';
  return AUTOMATION_SERVICE_ICON_MAP[service.slug] || service.logo;
};
