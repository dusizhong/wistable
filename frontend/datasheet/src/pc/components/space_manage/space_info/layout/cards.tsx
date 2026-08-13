import { useMemo } from 'react';
import { colors } from '@apitable/components';
import { Strings, t } from '@apitable/core';
import { useAutomation } from 'pc/components/space_manage/space_info/hooks/use_automation';
import { getEnvVariables, isMobileApp } from 'pc/utils/env';
import { Card, Info, MultiLineCard } from '../components';
import { expandFileModal } from '../components/file-modal';
import { useApi, useCapacity, useFile, useMember, useOthers, useRecord, useView } from '../hooks';
import { ILayoutProps } from '../interface';

interface ICardProps {
  minHeight?: string | number;
}

export const useCards = (props: ILayoutProps) => {
  const { showContextMenu, handleDelSpace, spaceInfo, spaceFeatures, subscription, isMobile } = props;
  const apiData = useApi({ spaceInfo, subscription });
  const automationData = useAutomation({ spaceInfo, subscription });
  const capacityData = useCapacity({ spaceInfo, subscription });
  const fileData = useFile({ spaceInfo, subscription });
  const recordData = useRecord({ spaceInfo, subscription });
  const memberData = useMember({ spaceInfo, subscription });
  const viewsData = useView({ spaceInfo, subscription });
  const othersData = useOthers({ spaceInfo, subscription });
  const infoProps = useMemo(() => {
    return {
      showContextMenu,
      handleDelSpace,
    };
  }, [showContextMenu, handleDelSpace]);

  const trailColor = colors.fc5;
  const strokeColor = colors.primaryColor;
  const hightLightColor = colors.primaryColor;

  const basicCert = useMemo(() => {
    return !!spaceFeatures && spaceFeatures.certification === 'basic';
  }, [spaceFeatures]);

  return useMemo(() => {
    return {
      InfoCard: (props: ICardProps) => (
        <Info {...props} {...infoProps} isMobile={isMobile} />
      ),
      MemberCard: (props: ICardProps) => (
        <Card
          {...props}
          {...memberData}
          isMobile={isMobile}
          shape="line"
          unit={t(Strings.people)}
          trailColor={trailColor}
          strokeColor={strokeColor}
          title={t(Strings.current_count_of_person)}
          titleTip={t(Strings.member_data_desc_of_member_number)}
        />
      ),

      ApiCard: (props: ICardProps) => (
        <Card
          {...props}
          {...apiData}
          isMobile={isMobile}
          shape="circle"
          unit={t(Strings.times_unit)}
          trailColor={trailColor}
          strokeColor={strokeColor}
          title={t(Strings.api_usage)}
          titleTip={t(Strings.api_usage_info)}
        />
      ),

      AutomationCard: (props: ICardProps) => (
        <Card
          {...props}
          {...automationData}
          isMobile={isMobile}
          shape="circle"
          unit={t(Strings.times_unit)}
          trailColor={trailColor}
          strokeColor={strokeColor}
          title={t(Strings.automation_run_usage)}
          titleTip={t(Strings.automation_run_usage_info)}
        />
      ),

      CapacityCard: (props: ICardProps) => {
        const titleLink =
          basicCert || isMobileApp() || isMobile || getEnvVariables().IS_SELFHOST || getEnvVariables().IS_APITABLE
            ? undefined
            : {
              text: t(Strings.attachment_capacity_details_entry),
              onClick: () => {},
            };

        return (
          <Card
            {...props}
            totalText={capacityData.allTotalText}
            remainText={capacityData.allRemainText}
            usedText={capacityData.allUsedText}
            usedPercent={capacityData.allUsedPercent}
            remainPercent={capacityData.allRemainPercent}
            isMobile={isMobile}
            usedTextIsFloat
            shape="circle"
            trailColor={trailColor}
            strokeColor={strokeColor}
            title={t(Strings.space_capacity)}
            titleTip={t(Strings.member_data_desc_of_appendix)}
            titleLink={titleLink}
          />
        );
      },

      FileCard: (props: ICardProps) => {
        const titleLink =
          basicCert || isMobileApp() || isMobile || getEnvVariables().IS_SELFHOST
            ? undefined
            : {
              text: t(Strings.attachment_capacity_details_entry),
              onClick: () => {
                expandFileModal(fileData.total);
              },
            };
        return (
          <Card
            {...props}
            {...fileData}
            isMobile={isMobile}
            shape="circle"
            unit={t(Strings.unit_ge)}
            trailColor={trailColor}
            strokeColor={strokeColor}
            title={t(Strings.datasheet_count)}
            titleTip={t(Strings.member_data_desc_of_field_number)}
            titleLink={titleLink}
          />
        );
      },

      RecordCard: (props: ICardProps) => (
        <Card
          {...props}
          {...recordData}
          isMobile={isMobile}
          shape="circle"
          unit={t(Strings.row)}
          trailColor={trailColor}
          strokeColor={strokeColor}
          title={t(Strings.total_records)}
          titleTip={t(Strings.member_data_desc_of_record_number)}
        />
      ),

      ViewsCard: (props: ICardProps) => (
        <MultiLineCard
          {...props}
          isMobile={isMobile}
          trailColor={trailColor}
          strokeColor={strokeColor}
          hightLight={hightLightColor}
          contentMargin={32}
          title={t(Strings.other_views)}
          titleTip={t(Strings.other_view_desc)}
          lines={viewsData}
        />
      ),

      OthersCard: (props: ICardProps) => (
        <MultiLineCard
          {...props}
          isMobile={isMobile}
          trailColor={trailColor}
          strokeColor={strokeColor}
          hightLight={hightLightColor}
          title={t(Strings.other_equitys)}
          titleTip={t(Strings.other_equitys_desc)}
          lines={othersData}
        />
      ),
    };
    // eslint-disable-next-line
  }, [handleDelSpace, spaceInfo, subscription, isMobile]);
};
